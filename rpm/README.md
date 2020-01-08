# Создание RPM и размещение в собственно репозитории

## Временно мусорка с заметками и ссылками

нужны репо:
sudo yum install -y wget git epel-release yum-utils rpm-build createrepo

ссылочка на src nginx 
http://nginx.org/packages/mainline/centos/7/SRPMS/nginx-1.11.10-1.el7.ngx.src.rpm

в качестве модуля был выбран sysguard, защищающий систему от хай-лоад нагрузки https://github.com/vozlt/nginx-module-sysguard
Источник https://www.nginx.com/resources/wiki/modules/

Склонируем репо себе git clone git://github.com/vozlt/nginx-module-sysguard.git
в раздел %build добавляем 
--add-module=/path/to/nginx-module-sysguard

      yum-builddep -y rpmbuild/SPECS/nginx.spec &&
      git clone git://github.com/vozlt/nginx-module-sysguard.git
      rpmbuild -bb rpmbuild/SPECS/nginx.spec &&
      yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.11.10* &&
      systemctl start nginx && systemctl enable nginx &&
      mkdir /usr/share/nginx/html/repo &&
      cp rpmbuild/RPMS/x86_64/nginx-1.11.10* /usr/share/nginx/html/repo/ &&
      wget https://www.percona.com/redir/downloads/percona-release/redhat/percona-release-1.0-13.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-1.0-13.noarch.rpm &&
      createrepo /usr/share/nginx/html/repo/


      --with-debug