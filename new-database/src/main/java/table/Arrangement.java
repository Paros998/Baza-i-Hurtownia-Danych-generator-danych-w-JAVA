package table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@Data
@Builder
public class Arrangement {
    private UUID id;
    private List<String> responsibilities;
    private List<String> requirements;
    private String typeOfArrangement;
}
