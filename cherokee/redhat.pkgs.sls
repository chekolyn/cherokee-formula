cherokee_install_pkgs:
  pkg.installed:
    - pkgs:
      - rrdtool
      - cherokee
    - require:
      - sls: epel