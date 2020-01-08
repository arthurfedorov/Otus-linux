yum install -y wget git epel-release yum-utils rpm-build createrepo &&
wget http://nginx.org/packages/mainline/centos/7/SRPMS/nginx-1.11.10-1.el7.ngx.src.rpm &&
rpm -i /home/vagrant nginx-1.11.10-1.el7.ngx.src.rpm &&
yum-builddep -y /home/vagrant/rpmbuild/SPECS/nginx.spec &&
git clone git://github.com/vozlt/nginx-module-sysguard.git &&
rpmbuild -bb /home/vagrant/rpmbuild/SPECS/nginx.spec