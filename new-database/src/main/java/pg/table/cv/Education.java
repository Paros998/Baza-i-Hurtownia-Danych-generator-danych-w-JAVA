package pg.table.cv;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Data
@NoArgsConstructor(staticName = "dummy")
@AllArgsConstructor
@Builder
public class Education implements CsvData {
    public static final String TABLE = "Wyksztalcenie";
    public static final String COLUMNS = "wyksztalcenie_id,cv_id,od,do,opis,nazwa";
    private UUID id;
    private CurriculumVitae cv;

    private LocalDate since;
    private LocalDate to;
    private String description;
    private String schoolName;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%s".formatted(
                id,
                cv.getId(),
                since.format(DateTimeFormatter.ISO_LOCAL_DATE),
                to.format(DateTimeFormatter.ISO_LOCAL_DATE),
                description,
                schoolName
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }
}