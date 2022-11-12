package pg.table.cv;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@NoArgsConstructor(staticName = "dummy")
@AllArgsConstructor
@Data
@Builder
public class Course implements CsvData {
    public static final String TABLE = "Kursy";
    public static final String COLUMNS = "kurs_id,cv_id,data,wazne_do,nazwa,opis";
    private UUID id;
    private CurriculumVitae cv;
    private LocalDate date;
    private LocalDate validTo;
    private String name;
    private String description;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s,%s".formatted(
                id,
                cv.getId(),
                date.format(DateTimeFormatter.ISO_LOCAL_DATE),
                validTo.format(DateTimeFormatter.ISO_LOCAL_DATE),
                name,
                description
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