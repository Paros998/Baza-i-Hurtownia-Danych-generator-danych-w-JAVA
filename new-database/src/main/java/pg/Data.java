package pg;

import lombok.Getter;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import pg.types.*;
import pg.utils.JsonLoader;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@Getter
public class Data {
    public static final String SCHEMA = "dbo";
    public final ObjectMapper objectMapper = new ObjectMapper();

    private final List<Address> addresses;
    private final List<Name> names;
    private final List<PersonalData> personalData;
    private final List<Company> companies;
    private final List<Course> courses;
    private final List<Education> educations;
    private final List<Experience> experiences;
    private final List<JobRequirement> jobRequirements;
    private final List<Test> tests;
    private final List<Skill> skills;
    private final List<Vacancy> vacancies;
    private final List<Employment> employments;

    private final List<String> emails;
    private final List<String> benefits;
    private final List<String> roles;
    private final List<String> phoneNumbers;
    private final List<String> requirements;
    private final List<String> responsibilities;
    private final List<String> jobSchedules;
    private final List<String> workArrangements;

    public Data() {
        addresses = readAndMapData(Address.class);
        names = readAndMapData(Name.class);
        personalData = readAndMapData(PersonalData.class);
        companies = readAndMapData(Company.class);
        courses = readAndMapData(Course.class);
        educations = readAndMapData(Education.class);
        experiences = readAndMapData(Experience.class);
        jobRequirements = readAndMapData(JobRequirement.class);
        tests = readAndMapData(Test.class);
        skills = readAndMapData(Skill.class);
        vacancies = readAndMapData(Vacancy.class);
        employments = readAndMapData(Employment.class);

        emails = readAndMapData("emails.json");
        benefits = readAndMapData("benefits.json");
        roles = readAndMapData("roles.json");
        phoneNumbers = readAndMapData("phones.json");
        requirements = readAndMapData("requirements.json");
        responsibilities = readAndMapData("responsibilities.json");
        jobSchedules = readAndMapData("job-schedules.json");
        workArrangements = readAndMapData("work-arrangements.json");
    }

    private <T> List<T> readAndMapData(final Class<T> clazz) {
        JavaType type = objectMapper.getTypeFactory().
                constructCollectionType(List.class, clazz);
        try {
            return objectMapper.readValue(JsonLoader.getData(clazz), type);
        } catch (IOException e) {
            return Collections.emptyList();
        }
    }

    private <T> List<T> readAndMapData(final String file) {
        try {
            return objectMapper.readValue(JsonLoader.getData(file), new TypeReference<>() {
            });
        } catch (IOException e) {
            return Collections.emptyList();
        }
    }
}