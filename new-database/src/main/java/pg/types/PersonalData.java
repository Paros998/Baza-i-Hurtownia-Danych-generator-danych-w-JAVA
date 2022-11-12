package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class PersonalData {
    public static final String FILE = "personal-data.json";

    private String personalNumber;
    private String birthDate;
}
