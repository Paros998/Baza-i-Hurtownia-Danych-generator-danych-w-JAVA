package table.vacancy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class JobRequirement {
    private UUID id;
    private Vacancy vacancy;
    private String name;
    private String description;
    private Integer experienceLevel;


    @Override
    public String toString() {
        return "%s,%s,%s,%s,%d".formatted(
                id,
                vacancy.getId(),
                name,
                description,
                experienceLevel
        );
    }
}