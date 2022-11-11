package table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class QualificationTest {
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
}