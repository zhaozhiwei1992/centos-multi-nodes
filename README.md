## 准备环境

需要准备以下软件和环境：

- 8G以上内存
- Vagrant 2.2+
- VirtualBox 6.1
- Linux

## 集群

使用Vagrant和Virtualbox安装包含3个节点的集群。

| IP           | 主机名   | 组件                 |
| ------------ | ----- | ----------------------- |
| 192.168.56.101 | node1 | docker                |
| 192.168.56.102 | node2 | docker                |
| 192.168.56.103 | node3 | docker                |

**注意**：以上的IP、主机名和组件都是固定在这些节点的，即使销毁后下次使用vagrant重建依然保持不变。

容器IP范围：192.168.56.0/21

## 安装的组件

安装完成后的集群包含以下组件：

## 使用说明

将该repo克隆到本地。

```bash
git clone https://github.com/zhaozhiwei1992/centos-multi-nodes.git
cd centos-multi-nodes
```

使用vagrant启动集群。

```bash
vagrant up
```

如果是首次部署，会自动下载`centos/7`的box，这需要花费一些时间，另外每个节点还需要下载安装一系列软件包，整个过程大概需要10几分钟。

如果您在运行`vagrant up`的过程中发现无法下载`centos/7`的box，可以手动下载后将其添加到vagrant中。

**手动添加centos/7 box**

````bash
wget -c http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box
vagrant box add CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box --name centos/7
````

这样下次运行`vagrant up`的时候就会自动读取本地的`centos/7` box而不会再到网上下载。

## 管理

除了特别说明，以下命令都在当前的repo目录下操作。

### 挂起

将当前的虚拟机挂起，以便下次恢复。

```bash
vagrant suspend
```

### 恢复

恢复虚拟机的上次状态。

```bash
vagrant resume
```

注意：我们每次挂起虚拟机后再重新启动它们的时候，看到的虚拟机中的时间依然是挂载时候的时间，这样将导致监控查看起来比较麻烦。因此请考虑先停机再重新启动虚拟机。

### 重启

停机后重启启动。

```bash
vagrant halt
vagrant up
# login to node1
vagrant ssh node1
exit
```
### 清理

清理虚拟机。

```bash
vagrant destroy
rm -rf .vagrant
```

### 注意

仅做开发测试使用，不要在生产环境使用该项目。

