import os
import re
import sys

def label_directory(mount_dir, contexts_file):
    # Load rules
    rules = []
    with open(contexts_file, "r") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split()
            if len(parts) >= 2:
                pattern = parts[0]
                label = parts[-1]
                try:
                    regex = re.compile("^" + pattern + "$")
                    rules.append((regex, label))
                except Exception:
                    pass
    
    print(f"Loaded {len(rules)} SELinux labeling rules.")
    
    # Label the root mount point itself
    try:
        os.setxattr(mount_dir, "security.selinux", b"u:object_r:vendor_file:s0\0")
        print(f"Labeled root mount point {mount_dir} with u:object_r:vendor_file:s0")
    except Exception as e:
        print(f"Failed to label root mount point: {e}")
    
    # Recursively traverse directory
    labeled_count = 0
    skipped_count = 0
    for root, dirs, files in os.walk(mount_dir):
        for name in dirs + files:
            full_path = os.path.join(root, name)
            
            # Construct target path relative to Android root
            rel_path = os.path.relpath(full_path, mount_dir)
            target_path = "/" + os.path.join("vendor", rel_path)
            
            # Find matching rule
            matched_label = None
            for regex, label in rules:
                if regex.match(target_path):
                    matched_label = label
                    break
            
            # Default fallback label if no rule matches
            if not matched_label:
                # Standard vendor fallback
                if "/bin/" in target_path:
                    matched_label = "u:object_r:vendor_file:s0"
                else:
                    matched_label = "u:object_r:vendor_file:s0"
            
            if matched_label:
                try:
                    os.setxattr(full_path, "security.selinux", matched_label.encode("utf-8") + b"\0")
                    labeled_count += 1
                except Exception as e:
                    print(f"Failed to label {full_path} with {matched_label}: {e}")
                    skipped_count += 1
                    
    print(f"Successfully labeled {labeled_count} files/directories. Failed/skipped: {skipped_count}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 label_vendor.py <mount_dir> <contexts_file>")
        sys.exit(1)
    label_directory(sys.argv[1], sys.argv[2])
