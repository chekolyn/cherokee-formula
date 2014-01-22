cherokee_install_pkgs:
  pkg.installed:
    - pkgs:
      - autoconf
      - automake
      - libtool
      - gettext
      - git
      - openssl-devel
      - screen

get-autoconf:
  file.managed:icons_dir
    - name: /usr/local/src/autoconf.tar.gz
    - source: http://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz
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
      
get-cherokee:
  cmd.wait:
    - cwd: /usr/local/src
    - names:
      - git clone --recursive https://github.com/cherokee/webserver.git
    - require:
      - cmd: autoconf
    - watch:
      - cmd: autoconf

cherokee:
  cmd.wait:
    - cwd: /usr/local/src/webserver
    - user: root
    - shell: /bin/bash 
    - env:
      - PATH: '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin'
    - names:
      - ./autogen.sh #--prefix=/usr --sysconfdir=/etc --localstatedir=/var
      - make && make install
    - watch:
      - cmd: get-cherokee
    - require:
      - cmd: get-cherokee

      
