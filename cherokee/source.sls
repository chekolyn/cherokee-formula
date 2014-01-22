{% from "cherokee/map.jinja" import cherokee with context %}

cherokee_install_pkgs:
  pkg.installed:
    - pkgs:
      - autoconf
      - automake
      - libtool
      - make
      - gettext
      - git
      - rrdtool
      - {{ cherokee.pkg_openssl_dev }}
      - screen
      
### Compiling notes Ubuntu:
# For ldap support: libldap2-dev
# For openssl: 'libssl-dev'
# For geoip: libgeoip-dev
# For mysql: libmysqlclient-dev
# For streaming support: apt-get install libavformat-dev libavcodec-dev libavcodec-extra-53 libavformat-extra-53


{% if grains['os_family'] == 'RedHat' %} 
get-autoconf:
  file.managed:
    - name: /usr/local/src/autoconf.tar.gz
    - source: http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
    - source_hash: 'md5=82d05e03b93e45f5a39b828dc9c6c29b'    
  cmd.wait:
    - cwd: /usr/local/src/
    - name: tar -zxf autoconf.tar.gz
    - watch:
      - file: get-autoconf

autoconf:
  cmd.wait:
    - cwd: /usr/local/src/autoconf-2.69
    - names:
      - ./configure
      - make 
      - make install
    - watch:
      - cmd: get-autoconf
    - require:
      - cmd: get-autoconf
      - pkg: cherokee_install_pkgs
      
{% endif %}
      
#get-cherokee-file:
#  file.managed:
#    - name: /usr/local/src/cherokee.zip
#    - source: https://github.com/cherokee/webserver/archive/v1.2.103.zip
#    - source_hash: 'md5=9e6d8e0dd95808d365d32ecb0a9b80fe'
#  cmd.wait:
#    - cwd: /usr/local/src/
#    - name: unzip cherokee.zip
#    - watch:
#      - file: get-cherokee-file
#    - require: 
#      - pkg: cherokee_install_pkgs
      
#get-cherokee-git:
#  cmd.run:
#    - cwd: /usr/local/src
#    - names:      
#      - git clone --recursive https://github.com/cherokee/webserver.git
#    - require:
#      - pkg: cherokee_install_pkgs
#    - watch:
#      - pkg: cherokee_install_pkgs
      
get-cherokee-git2:
  git.latest:
    - name: https://github.com/cherokee/webserver.git
    - rev: 'v1.2.103'
    - target: /usr/local/src/cherokee
    - submodules: True

cherokee-install:
  cmd.wait:
    - cwd: /usr/local/src/cherokee
    #- user: root
    #- shell: /bin/bash 
    #- env:
    #  - PATH: '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin'
    - names:
     # - uptime
      - './autogen.sh --prefix=/usr --sysconfdir=/etc --localstatedir=/var'
      - 'make && make install '
      - 'ldconfig'
    - watch:
      - git: get-cherokee-git2
    - require:
      - git: get-cherokee-git2