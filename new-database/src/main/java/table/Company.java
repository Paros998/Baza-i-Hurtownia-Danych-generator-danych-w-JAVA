package table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
@Builder
public class Company {
    private UUID id;
    private String companyName;
    private String address;
    private String email;
    private String identificationNumber;

    @Override
    public String toString() {
        return "%s,%s,%s,%s,%s".formatted(
                id,
                companyName,
                address,
                email,
                identificationNumber
        );
    }
}