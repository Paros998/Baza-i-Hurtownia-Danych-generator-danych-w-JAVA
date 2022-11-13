package pg.table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import pg.table.csv.CsvData;

import java.util.UUID;

@Data
@NoArgsConstructor(staticName = "dummy")
@AllArgsConstructor
@Builder
public class Company implements CsvData {
    public static final String TABLE = "Firma";
    public static final String COLUMNS = "firma_id,nazwa,adres,email,nip";
    private UUID id;
    private String companyName;
    private String address;
    private String email;
    private String identificationNumber;

    @Override
    public String toString() {
        return "%s,%s,[%s],%s,%s".formatted(
                id,
                companyName,
                address,
                email,
                identificationNumber
        );
    }

    @Override
    public String getColumns() {
        return COLUMNS;
    }
}