package table.cv;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@AllArgsConstructor
@Data
@Builder
public class Skill {
    private UUID id;
    private UUID cvId;
    private String name;
    // Between 1-5
    private Integer level;

    @Override
    public String toString() {
        return "%s,%s,%s,%d".formatted(
                id,
                cvId,
                name,
                level
        );
    }
}