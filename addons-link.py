#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import yaml
from glob import iglob, glob
from pprint import pformat

os.system("mkdir -p auto-addons")
dir_path = os.path.dirname(os.path.realpath(__file__))
ADDONS_YAML = "%s/addons.yaml" % dir_path
ADDONS_DIR = "%s/auto-addons" % dir_path
REPO_DIR = "%s/repository" % dir_path
MANIFESTS = ("__manifest__.py", "__openerp__.py")

print("Linking all addons...")

# Remove all links in addons dir
def remove_addons_link():
    for link in iglob(os.path.join(ADDONS_DIR, "*")):
        os.remove(link)
        print("Remove %s" % os.path.basename(link))
    return True

# Add new links
def add_addons_link():
    config = dict()
    missing_glob = set()
    missing_manifest = set()
    all_globs = {}
    try:
        with open(ADDONS_YAML) as addons_file:
            for doc in yaml.safe_load_all(addons_file):
                for repo, partial_globs in doc.items():
                   all_globs.setdefault(repo, set())
                   all_globs[repo].update(partial_globs)
    except IOError:
        print("Could not find addons configuration yaml.")
        raise SystemExit

    for repo, partial_globs in all_globs.items():
        for partial_glob in partial_globs:
            full_glob = os.path.join(REPO_DIR, repo, partial_glob)
            found = glob(full_glob)
            if not found:
                missing_glob.add(full_glob)
                continue
            for addon in found:
                if not os.path.isdir(addon):
                    continue
                manifests = (os.path.join(addon, m) for m in MANIFESTS)
                if not any(os.path.isfile(m) for m in manifests):
                    missing_manifest.add(addon)
                    continue
                addon = os.path.basename(addon)
                config.setdefault(addon, set())
                config[addon].add(repo)
    
    error = []
    if missing_glob:
        error += ["Addons not found:", pformat(missing_glob)]
    if missing_manifest:
        error += ["Addons without manifest:", pformat(missing_manifest)]
    if error:
        print("\n".join(error))
        raise SystemExit

    for addon, repos in config.items():
        if len(repos) != 1:
            print("Addon %s defined in several repos %s" % (addon, repos))
            raise SystemExit
        src = os.path.join(REPO_DIR, repos.pop(), addon)
        dst = os.path.join(ADDONS_DIR, addon)
        os.symlink(src, dst)
        print("Link %s" % addon)
    return True

remove_addons_link()
add_addons_link()

print("End...")