package pg;

import pg.generator.RecordsGenerator;
import pg.table.csv.CsvData;
import pg.utils.CsvWriter;
import pg.utils.Data;

public class DataGenerator {

    public static void main(String[] args) {
        final Data data = new Data();

        CsvWriter.createFiles(CsvData.tables);

        final RecordsGenerator recordsGenerator = RecordsGenerator.of(data);

        String numberOfFactsProperty = System.getProperty("records");

        int numberOfFacts;
        try {
            numberOfFacts = Integer.parseInt(numberOfFactsProperty);
        } catch (NumberFormatException e) {
            numberOfFacts = 10000;
        }

        recordsGenerator.generateFacts(numberOfFacts);
    }
}