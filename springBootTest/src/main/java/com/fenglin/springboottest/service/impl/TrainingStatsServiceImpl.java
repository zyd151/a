package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fenglin.springboottest.entity.TrainingStats;
import com.fenglin.springboottest.mapper.TrainingStatsMapper;
import com.fenglin.springboottest.service.TrainingStatsService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Service
public class TrainingStatsServiceImpl extends ServiceImpl<TrainingStatsMapper, TrainingStats> implements TrainingStatsService {

    @Override
    public TrainingStats getOrInit(String account) {
        TrainingStats one = getOne(Wrappers.<TrainingStats>lambdaQuery().eq(TrainingStats::getAccount, account));
        if (one == null) {
            one = new TrainingStats();
            one.setAccount(account);
            one.setWeekTrainCount(4);
            one.setTotalShots(1280);
            one.setHitRate(new BigDecimal("62.00"));
            save(one);
        }
        return one;
    }

    @Override
    @Transactional
    public TrainingStats record(String account, int shots, int hits) {
        if (hits > shots) {
            throw new RuntimeException("命中数不能大于投篮数");
        }
        TrainingStats s = getOrInit(account);
        int oldShots = s.getTotalShots() == null ? 0 : s.getTotalShots();
        BigDecimal oldRate = s.getHitRate() == null ? BigDecimal.ZERO : s.getHitRate();
        // 由历史命中率反推历史命中数，便于累加后重算
        double oldHits = oldShots * oldRate.doubleValue() / 100.0;

        int newShots = oldShots + shots;
        double newHits = oldHits + hits;
        BigDecimal newRate = newShots == 0 ? BigDecimal.ZERO
                : BigDecimal.valueOf(newHits / newShots * 100.0).setScale(2, RoundingMode.HALF_UP);

        s.setWeekTrainCount((s.getWeekTrainCount() == null ? 0 : s.getWeekTrainCount()) + 1);
        s.setTotalShots(newShots);
        s.setHitRate(newRate);
        updateById(s);
        return s;
    }
}
