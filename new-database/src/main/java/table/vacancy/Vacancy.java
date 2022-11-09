package table.vacancy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class Vacancy {
    private UUID id;
    private String sectorName;
    private String name;
    private String jobDescription;
    private Float lowestSalaryGap;
    private Float highestSalaryGap;
    // 1-5
    private Integer levelOfAdvancement;

    private List<Benefit> benefits;

    private List<JobRequirement> requirements;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%f,%f,%d".formatted(
                id,
                sectorName,
                name,
                jobDescription,
                lowestSalaryGap,
                highestSalaryGap,
                levelOfAdvancement
        );
    }
}