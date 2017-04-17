create table `ruby` (
  `id`   bigint(20) unsigned not null auto_increment,
  `uuid` varchar(191),
  primary key(`id`)
) engine=InnoDB default charset=utf8;

create table `python` (
  `id`   bigint(20) unsigned not null auto_increment,
  `uuid` varchar(191),
  primary key(`id`)
) engine=InnoDB default charset=utf8;

create table `node` (
  `id`   bigint(20) unsigned not null auto_increment,
  `uuid` varchar(191),
  primary key(`id`)
) engine=InnoDB default charset=utf8;
