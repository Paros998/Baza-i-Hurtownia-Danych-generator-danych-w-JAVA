package pg.table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@Data
@Builder
public class Arrangement {
    public static final String TABLE = "Umowa";
    public static final String COLUMNS = "umowa_id,obowiazki,wymogi,typ_umowy";

    private UUID id;
    private List<String> responsibilities;
    private List<String> requirements;
    private String typeOfArrangement;

    @Override
    public String toString() {
        return "%s,%s,%s,%s".formatted(
                id,
                responsibilities,
                requirements,
                typeOfArrangement
        );
    }
}
