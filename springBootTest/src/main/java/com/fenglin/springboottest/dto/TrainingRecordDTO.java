package com.fenglin.springboottest.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class TrainingRecordDTO {

    @NotNull(message = "投篮数不能为空")
    @Min(value = 1, message = "投篮数至少为 1")
    private Integer shots;

    @NotNull(message = "命中数不能为空")
    @Min(value = 0, message = "命中数不能为负")
    private Integer hits;
}
