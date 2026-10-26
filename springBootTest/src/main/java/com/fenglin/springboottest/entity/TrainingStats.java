package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("training_stats")
public class TrainingStats {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 关联用户账号 */
    private String account;

    /** 本周训练次数 */
    private Integer weekTrainCount;

    /** 累计投篮数 */
    private Integer totalShots;

    /** 命中率（百分比，如 62.00） */
    private BigDecimal hitRate;

    private LocalDateTime updatedAt;
}
