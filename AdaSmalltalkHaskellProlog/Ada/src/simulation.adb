with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;


procedure Simulation is

   Number_Of_Products: constant Integer := 5;
   Number_Of_Assemblies: constant Integer := 3;
   Number_Of_Consumers: constant Integer := 2;
   subtype Product_Type is Integer range 1 .. Number_Of_Products;
   subtype Assembly_Type is Integer range 1 .. Number_Of_Assemblies;
   subtype Consumer_Type is Integer range 1 .. Number_Of_Consumers;
   Product_Name: constant array (Product_Type) of String(1 .. 9) := ("Ham      ", "Mushroom ", "Salami   ", "Dough    ", "Cheese   ");
   Assembly_Name: constant array (Assembly_Type) of String(1 .. 10) := ("Capriciosa", "Pepperoni ", "Margharita");

   package Random_Assembly is new
     Ada.Numerics.Discrete_Random(Assembly_Type);

   task type Producer is
      entry Start(Product: in Product_Type);
   end Producer;

   task type Consumer is
      entry Start(Consumer_Number: in Consumer_Type);
   end Consumer;

   task type Buffer is
      entry Take(Product: in Product_Type; Number: in Integer; Accepted: out Boolean);
      entry Deliver(Assembly: in Assembly_Type; Number: out Integer; Accepted: out Boolean);
   end Buffer;

   P: array ( 1 .. Number_Of_Products ) of Producer;
   K: array ( 1 .. Number_Of_Consumers ) of Consumer;
   B: Buffer;


   -- Producer definition --
   task body Producer is
      subtype Production_Time_Range is Integer range 3 .. 6;
      package Random_Production is new
        Ada.Numerics.Discrete_Random(Production_Time_Range);
      G: Random_Production.Generator;
      Product_Type_Number: Integer;
      Product_Number: Integer;
      Production_Time: Integer;
      Accepted: Boolean;

   begin

      accept Start(Product: in Product_Type) do
         Random_Production.Reset(G);
         Product_Number := 1;
         Product_Type_Number := Product;
         Accepted := False;
      end Start;

      -- Producer life --
      Put_Line("[P] New producer of " & Product_Name(Product_Type_Number));
      loop
         Production_Time := Random_Production.Random(G); -- new random production time
         Put_Line("[P] Started producing " & Product_Name(Product_Type_Number) & " (est. time: " & Integer'Image(Production_Time) & " s)");
         delay Duration(Production_Time);
         Put_Line("[P] Produced product " & Product_Name(Product_Type_Number) & " number "  & Integer'Image(Product_Number));
         loop
            select
               B.Take(Product_Type_Number, Product_Number, Accepted);
               if Accepted then
                  Product_Number := Product_Number + 1;
                  Put_Line("[P] Succesfully delivered " & Product_Name(Product_Type_Number));
                  exit;
               else
                  Put_Line("[P] Buffer rejected " & Product_Name(Product_Type_Number) & " (try again in 5s)");
                  delay Duration(5.0);
               end if;
            else
               Put_Line("[P] Buffer is too busy at the moment.");
               delay Duration(5.0);
            end select;
         end loop;
      end loop;
   end Producer;


   -- Consumer definition --
   task body Consumer is
      subtype Consumption_Time_Range is Integer range 4 .. 8;
      package Random_Consumption is new
        Ada.Numerics.Discrete_Random(Consumption_Time_Range);
      G: Random_Consumption.Generator;
      G2: Random_Assembly.Generator;
      Consumer_Nb: Consumer_Type;
      Assembly_Number: Integer;
      Consumption: Integer;
      Assembly_Type: Integer;
      Accepted: Boolean;
      Consumer_Name: constant array (1 .. Number_Of_Consumers) of String(1 .. 9) := ("Pan Marek", "Pani Anna");

   begin

      accept Start(Consumer_Number: in Consumer_Type) do
         Random_Consumption.Reset(G);
         Random_Assembly.Reset(G2);
         Consumer_Nb := Consumer_Number;
         Accepted := False;
      end Start;

      -- Consumer life --
      Put_Line("");
      Put_Line("[C] New consumer " & Consumer_Name(Consumer_Nb));
      Put_Line("");
      loop
         Assembly_Type := Random_Assembly.Random(G2);
         Consumption := Random_Consumption.Random(G);
         Put_Line("");
         Put_Line("[C] " & Consumer_Name(Consumer_Nb) & " thinks what to eat today");
         Put_Line("");
         delay Duration(Consumption);
         Put_Line("");
         Put_Line("[C] " & Consumer_Name(Consumer_Nb) & " wants " & Assembly_Name(Assembly_Type));
         Put_Line("");
         loop
            select
               B.Deliver(Assembly_Type, Assembly_Number, Accepted);
               if Accepted then
                  Put_Line("");
                  Put_Line("[C] " & Consumer_Name(Consumer_Nb) & ": taken pizza " & Assembly_Name(Assembly_Type) & " number " & Integer'Image(Assembly_Number));
                  Put_Line("");
                  exit;
               else
                  Put_Line("");
                  Put_Line("[C " & Consumer_Name(Consumer_Nb) & "]" &  "Not enough products for " & Assembly_Name(Assembly_Type) & " (waiting 3s)");
                  Put_Line("");
                  delay Duration(3.0);
               end if;
            or delay Duration(10.0);
               Put_Line("");
               Put_Line("[C] " & Consumer_Name(Consumer_Nb) & " got angry and left the restaurant");
               Put_Line("");
               delay Duration(5.0);
               exit;
            end select;
         end loop;
      end loop;
   end Consumer;



   -- Buffer definition --
   task body Buffer is

      Storage_Capacity: constant Integer := 30;
      isFull: exception;
      type Storage_type is array (Product_Type) of Integer;
      Storage: Storage_type := (0, 0, 0, 0, 0); -- no starting products
      Assembly_Content: array(Assembly_Type, Product_Type) of Integer := (
                                                                          (2, 2, 0, 2, 2), -- capriciosa
                                                                          (0, 0, 2, 2, 2), -- pepperoni
                                                                          (0, 0, 0, 2, 2)); -- margharita
      Max_Assembly_Content: array(Product_Type) of Integer;
      Assembly_Number: array(Assembly_Type) of Integer := (1, 1, 1);
      In_Storage: Integer := 0;


      procedure Setup_Variables is
      begin
         for W in Product_Type loop
            Max_Assembly_Content(W) := 0;
            for Z in Assembly_Type loop
               Max_Assembly_Content(W) := Max_Assembly_Content(W) + Assembly_Content(Z, W);
            end loop;
            Max_Assembly_Content(W) := Max_Assembly_Content(w) * 2;
         end loop;
      end Setup_Variables;

      procedure Clear_Variables is
      begin
         In_Storage := 0;
         for P in Product_Type loop
            Storage(P) := 0;
         end loop;
      end Clear_Variables;

      function Can_Accept(Product: Product_Type) return Boolean is
         Free: Integer;
         MP: Boolean;
      begin
         if In_Storage >= Storage_Capacity then
            raise isFull;
            return False;
         end if;

         Free := Storage_Capacity - In_Storage;
         MP := true;
         if Storage(Product) >= Max_Assembly_Content(Product) then
            for I in Product_Type loop
               if Storage(I) < Max_Assembly_Content(I) then
                  MP := false;
                  exit;
               end if;
            end loop;

            if MP then
               return True;
            else
               Put_Line("[B] We got enough of " & Product_Name(Product) & " in storage!");
               return False;
            end if;
         else
            return True;
         end if;
      end Can_Accept;


      function Can_Deliver(Assembly: Assembly_Type) return Boolean is
      begin
         for W in Product_Type loop
            if Storage(W) < Assembly_Content(Assembly, W) then
               return False;
            end if;
         end loop;
         return True;
      end Can_Deliver;


      procedure Storage_Contents is
      begin

         Put_Line("[S] Contents: " & Integer'Image(Storage(1)) & " " & Product_Name(1)
                  & Integer'Image(Storage(2)) & " " & Product_Name(2)
                  & Integer'Image(Storage(3)) & " " & Product_Name(3)
                  & Integer'Image(Storage(4)) & " " & Product_Name(4)
                  & Integer'Image(Storage(5)) & " " & Product_Name(5));

      end Storage_Contents;

   begin

      Put_Line("[B] Pizzeria has opened");
      Setup_Variables;
      Storage_Contents;
      loop
         select

            accept Take(Product: in Product_Type; Number: in Integer; Accepted: out Boolean) do
               if Can_Accept(Product) then
                  Storage(Product) := Storage(Product) + 1;
                  In_Storage := In_Storage + 1;
                  Accepted := True;
                  delay Duration(0.5);
               else
                  Accepted := False;
               end if;
            exception
               when isFull =>
                  Put_Line("[B]EXCEPTION: Storage is full!");
                  Clear_Variables;
            end Take;
            Storage_Contents;

         or

            accept Deliver(Assembly: in Assembly_Type; Number: out Integer; Accepted: out Boolean) do
               if Can_Deliver(Assembly) then
                  for W in Product_Type loop
                     Storage(W) := Storage(W) - Assembly_Content(Assembly, W);
                     In_Storage := In_Storage - Assembly_Content(Assembly, W);
                  end loop;
                  Number := Assembly_Number(Assembly);
                  Assembly_Number(Assembly) := Assembly_Number(Assembly) + 1;
                  Accepted := True;
                  delay Duration(10.0);
               else
                  Number := 0;
                  Accepted := False;
               end if;
            end Deliver;
            Storage_Contents;

         end select;
      end loop;
   end Buffer;



begin
   for I in 1 .. Number_Of_Products loop
      P(I).Start(I);
   end loop;
   for J in 1 .. Number_Of_Consumers loop
      K(J).Start(J);
   end loop;
end Simulation;
