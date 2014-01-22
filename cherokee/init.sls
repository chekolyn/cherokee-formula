{% if grains['os_family'] == 'RedHat' and pillar.get('cherokee', {}).get('install_from_source') == False %} 
include:
  - epel
  - cherokee.redhat.pkgs
  - cherokee.common
      
{% elif grains['os_family'] == 'Debian'  or grains['os_family'] == 'RedHat' %}
include:
  - cherokee.source
  - cherokee.common
{% endif %}