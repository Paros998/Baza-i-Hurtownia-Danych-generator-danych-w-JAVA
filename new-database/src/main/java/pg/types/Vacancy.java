package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Vacancy {
    public static final String FILE = "vacancies.json";

    private Integer levelOfAdvancement;
    private String sectorName;
    private String name;
    private Float highestSalaryGap;
    private Float lowestSalaryGap;
}
