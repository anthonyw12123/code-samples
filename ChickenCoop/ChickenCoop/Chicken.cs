using System;
using System.Text;
using Newtonsoft.Json;

namespace TimeServer
{
    public class Chicken
    {
        private Guid? iD;

        [JsonProperty]
        public string Name { get; set; }
        [JsonProperty]
        public int Age { get; set; }
        [JsonProperty]
        public Gender Gender { get; set; }
        [JsonProperty]
        public Guid ID {
            get
            {
                if (!iD.HasValue)
                {
                    iD = Guid.NewGuid();
                }
                return iD.Value;
            }
            set
            {
                this.iD = value;
            }
        }

        public override string ToString()
        {
            StringBuilder builder = new StringBuilder();
            builder.AppendLine("Chicken!");
            builder.AppendLine($"\tName: {this.Name}");
            builder.AppendLine($"\tAge: {this.Age}");
            builder.AppendLine($"\tGender: {Enum.GetName(typeof(Gender), this.Gender)}");
            return builder.ToString();
        }

        public Chicken(Gender gender, int age, string name)
        {
            this.Gender = gender;
            this.Age = age;
            this.Name = name;
        }

        [JsonConstructor]
        public Chicken(string name, string age, string gender)
        {
            this.Age = Int32.Parse(age);
            this.Name = name;
            this.Gender = (Gender)Enum.Parse(typeof(Gender),gender.ToString());
        }

        public Chicken()
        {

        }

        public override bool Equals(Object obj)
        {
            if (obj == null) return false;
            Chicken objAsChicken = obj as Chicken;
            if (objAsChicken == null) return false;
            else return Equals(objAsChicken);
        }

        public bool Equals(Chicken chicken)
        {
            return this.ID == chicken.ID;
        }
    }

    public enum Gender
    {
        Male, Female
    }
}
