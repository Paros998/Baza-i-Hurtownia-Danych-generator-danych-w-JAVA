package pg.table.vacancy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class Vacancy {
    public static final String TABLE = "Stanowisko";
    public static final String COLUMNS = "stanowisko_id,nazwa,nazwa_sektora,opis,widelki_od,widelki_do,stopień_zaawansowania";
    private UUID id;
    private String name;
    private String sectorName;
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
                name,
                sectorName,
                jobDescription,
                lowestSalaryGap,
                highestSalaryGap,
                levelOfAdvancement
        );
    }
}