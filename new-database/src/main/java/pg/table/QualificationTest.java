package pg.table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor(staticName = "dummy")
@Builder
public class QualificationTest implements CsvData {
    public static final String TABLE = "Test_Kwalifikacyjny";
    public static final String COLUMNS = "test_id,nazwa,opis_czynnosci,stopien_trudnosci";

    private UUID id;
    private String name;
    private String description;
    private Integer difficultyLevel;

    @Override
    public String toString() {
        return "%s,%s,%s,%d".formatted(
                id,
                name,
                description,
                difficultyLevel
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }
}