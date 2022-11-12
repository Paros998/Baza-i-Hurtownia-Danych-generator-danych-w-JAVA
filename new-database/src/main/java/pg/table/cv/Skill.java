package pg.table.cv;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor(staticName = "dummy")
@Data
@Builder
public class Skill implements CsvData {
    public static final String TABLE = "Umiejetnosci";
    public static final String COLUMNS = "umiejetnosc_id,cv_id,nazwa,stopien";
    private UUID id;
    private CurriculumVitae cv;
    private String name;
    // Between 1-5
    private Integer level;

    @Override
    public String toString() {
        return "%s,%s,%s,%d".formatted(
                id,
                cv.getId(),
                name,
                level
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }

    @Override
    public String getData() {
        return this.toString();
    }
}