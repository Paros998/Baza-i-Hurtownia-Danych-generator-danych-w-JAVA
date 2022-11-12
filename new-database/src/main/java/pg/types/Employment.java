package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Employment {
    public static final String FILE = "employments.json";

    private Integer amountOfApplicationsForVacancy;
    private String dateOfEmployment;
    private Integer arrangementYears;
    private Integer numberOfFirmEmployeesNow;
    private Integer arrangementMonths;
    private Float beginningSalary;
}