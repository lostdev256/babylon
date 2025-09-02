#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
sys.dont_write_bytecode = True

import os
import glob
import uuid
import lxml.etree as xml


def prepare_filters(filters):
    all_filters = set()
    for filter_id in filters:
        parts = filter_id.split('\\')
        collected_parts = list()
        for part in parts:
            collected_parts.append(part)
            all_filters.add('\\'.join(collected_parts))

    return all_filters


def fix_vs_project_filters(build_dir):
    print('Fixing VS prohect filters...')

    for path in glob.glob(os.path.join(build_dir, '**/*.vcxproj.filters'), recursive=True):
        filters = set()
        includes = dict()
        compiles = dict()
        nones = set()

        xml_doc = xml.parse(path)
        xml_root = xml_doc.getroot()

        if xml_root is None:
            print(f'Error while reading {path}')
            continue

        ns = xml.QName(xml_root).namespace
        if ns is None:
            ns = ''
        if ns != '':
            ns = f'{{{ns}}}'

        for xml_filter in xml_root.iter(f'{ns}Filter'):
            filter_id = xml_filter.get('Include', '')
            if filter_id == '':
                    continue
            
            filter_id = filter_id.replace('/', '\\')
            filters.add(filter_id)

        for xml_include in xml_root.iter(f'{ns}ClInclude'):
            include_path = xml_include.get('Include', '')
            if include_path == '':
                continue
        
            include_path = include_path.replace('/', '\\')
        
            xml_filter = xml_include.find(f'{ns}Filter')
            if xml_filter is None:
                filter_id = ''
            else:
                filter_id = xml_filter.text
            filter_id = filter_id.replace('/', '\\')

            includes[include_path] = filter_id

        for xml_compile in xml_root.iter(f'{ns}ClCompile'):
            include_path = xml_compile.get('Include', '')
            if include_path == '':
                continue
        
            include_path = include_path.replace('/', '\\')
        
            xml_filter = xml_compile.find(f'{ns}Filter')
            if xml_filter is None:
                filter_id = ''
            else:
                filter_id = xml_filter.text
            filter_id = filter_id.replace('/', '\\')

            compiles[include_path] = filter_id

        for xml_none in xml_root.iter(f'{ns}None'):
            include_path = xml_none.get('Include', '')
            if include_path == '':
                continue
        
            include_path = include_path.replace('/', '\\')

            nones.add(include_path)

        for xml_child in list(xml_root):
            xml_root.remove(xml_child)
        
        filters = prepare_filters(filters)

        xml_item_group = xml.SubElement(xml_root, "ItemGroup")
        for filter_id in filters:
            xml_filter = xml.SubElement(xml_item_group, "Filter")
            xml_filter.set('Include', filter_id)
            xml_uid = xml.SubElement(xml_filter, "UniqueIdentifier")
            uid = str(uuid.uuid4()).upper()
            xml_uid.text = f'{{{uid}}}'

        xml_item_group = xml.SubElement(xml_root, "ItemGroup")
        for include_path, filter_id in includes.items():
            xml_include = xml.SubElement(xml_item_group, "ClInclude")
            xml_include.set('Include', include_path)
            if filter_id != '':
                xml_filter = xml.SubElement(xml_include, "Filter")
                xml_filter.text = filter_id

        xml_item_group = xml.SubElement(xml_root, "ItemGroup")
        for include_path, filter_id in compiles.items():
            xml_include = xml.SubElement(xml_item_group, "ClCompile")
            xml_include.set('Include', include_path)
            if filter_id != '':
                xml_filter = xml.SubElement(xml_include, "Filter")
                xml_filter.text = filter_id

        xml_item_group = xml.SubElement(xml_root, "ItemGroup")
        for include_path in nones:
            xml_none = xml.SubElement(xml_item_group, "None")
            xml_none.set('Include', include_path)

        xml_doc.write(path, pretty_print=True, xml_declaration=True, encoding="UTF-8")

if __name__ == '__main__':
    if len(sys.argv) > 1:
        fix_vs_project_filters(sys.argv[1])
    else:
        print('Build directory not specified!')
