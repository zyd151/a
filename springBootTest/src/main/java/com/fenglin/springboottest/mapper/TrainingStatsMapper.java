package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.TrainingStats;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TrainingStatsMapper extends BaseMapper<TrainingStats> {
}
