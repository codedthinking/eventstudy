import sys
import frontmatter
import jinja2
import datetime

pkg_template = '''
v 3

d {{title}}
d
d Authors: {{author}}
d Support: 
d {% for line in description.split('\n') %}
d {{line}}{% endfor %}
d For details, see website:
d {{url}}
d
d Requires: {{requires}}
d
d Distribution-Date: {{stata_date}}
d

{% for f in files %}
f {{f}}{% endfor %}
'''

toc_template = '''
v 3
d {{author}}
d {{url}}
p {{command}} {{title}}
'''

citation_template = '''
cff-version: 1.2.0
title: {{title}}
message: >-
  If you use this software, please cite it using the
  metadata from this file.
type: software
authors:
  - given-names: 
    family-names: '{{author}}'
identifiers:
  - type: url
    value: '{{url}}'
version: {{version}}
date-released: '{{date}}'
'''

def render_pkg(config):
    return jinja2.Template(pkg_template).render(config)

def render_toc(config):
    return jinja2.Template(toc_template).render(config)

def render_citation(config):
    return jinja2.Template(citation_template).render(config)

def stata_date(dt: datetime.date):
    return f'{dt.year}{dt.month:02}{dt.day:02}'

def version_date(dt: datetime.date):
    # 2019-10-09 -> 09oct2019
    # 2023-03-01 -> 01mar2023
    return f'{dt.day:02}{dt.strftime("%b").lower()}{dt.year}'

def replace_version(config, text):
    version = f'*! version {config["version"]} {version_date(config["date"])}'
    lines = [version if line[0:2] == '*!' else line for line in text.split('\n')]
    return '\n'.join(lines)


if __name__ == '__main__':
    config = frontmatter.load(sys.argv[1])
    command = sys.argv[2]
    config['command'] = command
    config['stata_date'] = stata_date(config['date'])
    with open('files.txt', 'rt') as f:
        files = f.readlines()
    config['files'] = [f.strip() for f in files]
    with open(f'{command}.ado', 'rt') as f:
        adotext = f.read()
    with open(f'{command}.pkg', 'wt') as f:
        f.write(render_pkg(config))
    with open(f'stata.toc', 'wt') as f:
        f.write(render_toc(config))
    with open('CITATION.cff', 'wt') as f:
        f.write(render_citation(config))
    with open(f'{command}.ado', 'wt') as f:
        f.write(replace_version(config, adotext))

