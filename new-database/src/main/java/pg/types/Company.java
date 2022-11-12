package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Company {
    public static final String FILE = "company.json";

    private String companyName;
    private String email;
    private String address;
    private String identificationNumber;
}
