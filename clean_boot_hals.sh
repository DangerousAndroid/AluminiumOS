#!/bin/bash
echo "Finding boot HALs in vendor folder"
python3 -c "
import os
import xml.etree.ElementTree as ET

vintf_dir = 'p9pf/vendor/etc/vintf/'
for root, dirs, files in os.walk(vintf_dir):
    for file in files:
        if file.endswith('.xml'):
            filepath = os.path.join(root, file)
            try:
                tree = ET.parse(filepath)
                xml_root = tree.getroot()
                changed = False
                for hal in xml_root.findall('hal'):
                    name_node = hal.find('name')
                    if name_node is not None and name_node.text == 'android.hardware.boot':
                        xml_root.remove(hal)
                        changed = True
                if changed:
                    tree.write(filepath, encoding='utf-8', xml_declaration=True)
                    print(f'-> Successfully removed Boot HAL declaration from: {filepath}')
            except Exception:
                pass
"
echo "Boot HALs deleted!"
