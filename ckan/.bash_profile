# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH


CKAN_SAML_SP_URL=http://localhost:8081


PATH=$PATH:$HOME/.local/bin:$HOME/bin:/usr/lib/ckan/default/bin:/opt/solr/bin
. /usr/lib/ckan/default/bin/activate
alias ckanserve='paster --plugin=ckan serve --reload /etc/ckan/default/development.ini'
alias dbupgrade='paster --plugin=ckan db upgrade  -c /etc/ckan/default/development.ini'
alias dbinit='paster --plugin=ckan db init -c /etc/ckan/default/development.ini'
alias dbclean='paster --plugin=ckan db clean -c /etc/ckan/default/development.ini'
alias indexrebuild='paster --plugin=ckan search-index rebuild -c /etc/ckan/default/development.ini'
alias dbcreatemodel='paster --plugin=ckan db create-from-model -c /etc/ckan/default/development.ini'
alias userlist='paster --plugin=ckan user list -c /etc/ckan/default/development.ini'
alias userdo='paster --plugin=ckan user -c /etc/ckan/default/development.ini'
alias sysadmin='paster --plugin=ckan sysadmin add --config=/etc/ckan/default/development.ini'
