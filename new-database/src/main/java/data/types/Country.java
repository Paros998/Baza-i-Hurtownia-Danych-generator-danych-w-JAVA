package data.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Country {
    public static final String FILE = "countries.json";

    private Integer id;
    private String alpha2;
    private String alpha3;
    private String name;
}
