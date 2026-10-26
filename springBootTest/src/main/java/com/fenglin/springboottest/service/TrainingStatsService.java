package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.fenglin.springboottest.entity.TrainingStats;

public interface TrainingStatsService extends IService<TrainingStats> {

    /**
     * 获取指定账号的训练统计；若尚未初始化，则写入一条默认数据并返回
     */
    TrainingStats getOrInit(String account);

    /**
     * 记录一次训练，更新累计数据
     *
     * @throws RuntimeException 命中数大于投篮数时抛出，信息为 "命中数不能大于投篮数"
     */
    TrainingStats record(String account, int shots, int hits);
}
