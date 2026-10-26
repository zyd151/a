-- ============================================================
-- HoopLab 用户库初始化脚本
-- 数据库：hooplab
-- 字符集：utf8mb4
-- 说明：在本地 MySQL（root / 123456）执行本文件即可建库建表
-- ============================================================

CREATE DATABASE IF NOT EXISTS `hooplab`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE `hooplab`;

-- 删除旧表（首次执行可忽略警告）
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account`    VARCHAR(64)  NOT NULL                COMMENT '登录账号（手机号 / 邮箱）',
  `password`   VARCHAR(128) NOT NULL                COMMENT '密码（演示用明文，生产请加密存储）',
  `nickname`   VARCHAR(64)  DEFAULT NULL            COMMENT '昵称',
  `created_at` DATETIME     DEFAULT CURRENT_TIMESTAMP                     COMMENT '创建时间',
  `updated_at` DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 训练统计表（每个用户一条记录）
DROP TABLE IF EXISTS `training_stats`;

CREATE TABLE `training_stats` (
  `id`               BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account`          VARCHAR(64)  NOT NULL                COMMENT '关联用户账号',
  `week_train_count` INT          DEFAULT 0               COMMENT '本周训练次数',
  `total_shots`      INT          DEFAULT 0               COMMENT '累计投篮数',
  `hit_rate`         DECIMAL(5,2) DEFAULT 0.00            COMMENT '命中率（百分比）',
  `updated_at`       DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='训练统计表';
