module A_1;

// Part A =====================================================================================================================

logic signed [3:0] a;
bit [7:0] b;
shortint c;
bit [3:0] d;
real r;
string myString = "SV Assignment";

initial begin
    
    a = -3;
    $display("a = %0d\n", a);
    
    b = 250;
    $display("b = %0d\n", b);

    c = -12345;
    $display("c = %0d\n", c);

    #5ns
    d = 4'b1101;
    $display("d = %b\n", d);

    #15ns
    r = 3.144159;
    $display("r = %5f\n", r);
    $display("myString = %s\n", myString);
end

// Part B =====================================================================================================================
int arr_0 [4:0] = '{1, 2, 3, 4, 5};
logic [2:0] [1:0] arr_1 = '{default:2'b10};
byte arr_2 [3:0] = '{10, 20, 30, 40};

initial begin

    $display("arr_0  = %p\n", arr_0);
    $display("arr_1 = %p\n", arr_1);
    $display("arr_2 = %p\n", arr_2);
end

//=====================================================================================================================

typedef struct {
    string name;
    int id;
    byte grade;
} student_t;

student_t students [2:0];

initial begin

    students[0] = '{"Ali", 1, 85}; 
    students[1] = '{"Sara", 2, 90};   
    students[2] = '{"Omar", 3, 78}; 
    
    $display("Name <%s> : ID<%0d> : Grade<%0d>\n", students[0].name, students[0].id, students[0].grade);
    $display("Name <%s> : ID<%0d> : Grade<%0d>\n", students[1].name, students[1].id, students[1].grade);
    $display("Name <%s> : ID<%0d> : Grade<%0d>\n", students[2].name, students[2].id, students[2].grade);
end

//=====================================================================================================================

typedef union {
    int i;
    byte b;
} data_u;

data_u data;

initial begin

    data.i = 32'h12345678;
    $display("data.i = %h\n", data.i);
    $display("data.b = %h\n", data.b);
end

initial begin

    data.i = 8'h12;
    $display("data.i = %h\n", data.i);
    $display("data.b = %h\n", data.b);
end


endmodule