#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import yaml
from glob import iglob, glob
from pprint import pformat

dir_path = os.path.dirname(os.path.realpath(__file__))
ADDONS_YAML = os.path.join(dir_path, "addons.yaml")
ADDONS_DIR = os.path.join(dir_path, "auto-addons")
REPO_DIR = os.path.join(dir_path, "repository")
MANIFESTS = ("__manifest__.py", "__openerp__.py")
os.system("mkdir -p %s" % ADDONS_DIR)

print("Copying all addons...")

# Remove all addons in ADDONS_DIR
def remove_addons():
    for path in iglob(os.path.join(ADDONS_DIR, "*")):
        os.system("rm -r %s" % path)
        print("Remove %s" % os.path.basename(path))
    return True

# Copy all addons with related ADDONS_YAML
def copy_addons():
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
        error += ["Addons not found: %s" % pformat(missing_glob)]
    if missing_manifest:
        error += ["Addons without manifest: %s" % pformat(missing_manifest)]
    if error:
        print("\n".join(error))
        raise SystemExit

    for addon, repos in config.items():
        if len(repos) != 1:
            print("Addon %s defined in several repos %s" % (addon, repos))
            raise SystemExit
        src = os.path.join(REPO_DIR, repos.pop(), addon)
        dst = os.path.join(ADDONS_DIR, addon)
        os.system("cp -r %s %s" % (src, dst))
        print("Copy %s" % addon)
    return True

remove_addons()
copy_addons()

print("End...")