{% from "cherokee/map.jinja" import cherokee with context %}

/etc/cherokee:
  file.directory:
    - user: root
    - group: root

/etc/cherokee/cherokee.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - source: salt://cherokee/templates/cherokee.conf.jinja
    - require:
      - file: /etc/cherokee
    - backup: minion

/etc/init.d/cherokee:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 775
    - source: salt://cherokee/templates/{{ grains['os_family'] }}/etc.init.d.cherokee
    
/etc/logrotate.d/cherokee:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://cherokee/templates/{{ grains['os_family'] }}/etc.logrotate.d.cherokee

/var/lib/cherokee/graphs:
  file.directory:
    - user: {{ cherokee.user }}
    - group: {{ cherokee.group }}
    - mode: 775

/var/log/cherokee:
  file.directory:
    - user: root
    - group: root
    - mode: 775

cherokee:
  service:
    - running
    - required:
      - file: /etc/cherokee/cherokee.conf
    - name: cherokee
    - enable: True
    - sig: cherokee
    - watch:
      - file:  /etc/cherokee/cherokee.conf
    - order: last