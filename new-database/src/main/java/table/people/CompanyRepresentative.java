package table.people;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@AllArgsConstructor
@Data
@Builder
public class CompanyRepresentative {
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
}