package pg.table.vacancy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor(staticName = "dummy")
@Builder
public class Vacancy implements CsvData {
    public static final String TABLE = "Stanowisko";
    public static final String COLUMNS = "stanowisko_id,nazwa,nazwa_sektora,opis,widelki_od,widelki_do,stopień_zaawansowania";
    private UUID id;
    private String name;
    private String sectorName;
    private String jobDescription;
    private Float lowestSalaryGap;
    private Float highestSalaryGap;
    private Integer levelOfAdvancement;
    private String workSchedule;

    private List<Benefit> benefits;

    private List<JobRequirement> requirements;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%f.2,%f.2,%d,%s".formatted(
                id,
                name,
                sectorName,
                jobDescription,
                lowestSalaryGap,
                highestSalaryGap,
                levelOfAdvancement,
                workSchedule
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }
}