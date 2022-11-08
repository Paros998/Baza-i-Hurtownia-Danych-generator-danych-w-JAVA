package table.vacancy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@AllArgsConstructor
@Data
@Builder
public class Benefit {
    private UUID id;
    private Vacancy vacancy;
    private String description;
    private Float amount;

    @Override
    public String toString() {
        return "%s,%s,%s,%f".formatted(
                id,
                vacancy.getId(),
                description,
                amount
        );
    }
}