yum install -y wget git epel-release yum-utils rpm-build createrepo &&
mkdir -p /tmp/nginx && cd /tmp/nginx &&
wget http://nginx.org/packages/mainline/centos/7/SRPMS/nginx-1.11.10-1.el7.ngx.src.rpm &&
rpm -i /tmp/nginx/nginx-1.11.10-1.el7.ngx.src.rpm &&
yum-builddep -y /tmp/nginx/rpmbuild/SPECS/nginx.spec
