package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Address {
    public static final String FILE = "address.json";

    private String street;
    private String country;
    private String postalCode;
    private String voivodeship;
    private String city;
}
