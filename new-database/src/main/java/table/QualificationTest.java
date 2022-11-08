package table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class QualificationTest {
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