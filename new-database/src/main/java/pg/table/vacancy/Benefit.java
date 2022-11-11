package pg.table.vacancy;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@AllArgsConstructor
@Data
@Builder
public class Benefit {
    public static final String TABLE = "Bonusy";
    public static final String COLUMNS = "bonus_id,stanowisko_id,opis,wartosc,nazwa";
    private UUID id;
    private Vacancy vacancy;
    private String description;
    private Float amount;
    private String name;

    @Override
    public String toString() {
        return "%s,%s,%s,%f,%s".formatted(
                id,
                vacancy.getId(),
                description,
                amount,
                name
        );
    }
}