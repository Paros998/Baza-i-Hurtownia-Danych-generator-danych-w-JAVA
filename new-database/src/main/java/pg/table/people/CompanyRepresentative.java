package pg.table.people;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor(staticName = "dummy")
@Data
@Builder
public class CompanyRepresentative implements CsvData {
    public static final String TABLE = "Reprezentant_firmy";
    public static final String COLUMNS = "reprezentant_id,nazwisko,imie,rola_w_firmie";
    private UUID id;
    private String firstName;
    private String lastName;
    private String role;

    @Override
    public String toString() {
        return "%s,%s,%s,%s".formatted(
                id,
                firstName,
                lastName,
                role
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }
}