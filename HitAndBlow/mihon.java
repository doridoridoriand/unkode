package jp.setchi.HitAndBlow;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.Random;
import java.util.Scanner;
import java.util.Set;

public class Main {
  static final int NUMBER_OF_DIGITS = 4;
  
  public static void main(String[] args) {
    String expectedAnswer = generateRandomAnswer(NUMBER_OF_DIGITS);
    
    try (Scanner scanner = new Scanner(System.in)) {
      
      for (int countPlay = 1; ; countPlay++) {
        
        System.out.println(NUMBER_OF_DIGITS + "桁の数値を入力してください。(" + countPlay + "回目)");
        String answer = scanner.next();
        
        if (answer.length() != NUMBER_OF_DIGITS) {
          System.out.println("入力が" + NUMBER_OF_DIGITS + "桁ではありません。");
          continue;
        }
        
        if (!answer.matches("\\d+")) {
          System.out.println("入力は数値のみです。");
          continue;
        }
        
        if (isDuplicated(answer)) {
          System.out.println("入力に重複があります。");
          continue;
        }
        
        HitAndBlow result = countHitsAndBlows(answer, expectedAnswer);
        System.out.println("ヒット：" + result.getHits() +  ", ブロウ：" + result.getBlows());
        
        if (result.getHits() == NUMBER_OF_DIGITS) {
          System.out.println(countPlay + "回目でクリア！");
          System.out.println("おめでとうございます！");
          break;
        }
      }
    }
  }
  
  static String generateRandomAnswer(int digits) {
    LinkedList<Integer> unusedNumbers = new LinkedList<>();
    
    for (int i = 0; i < 10; i++) {
      unusedNumbers.add(i);
    }
    
    char[] answer = new char[digits];
    Random random = new Random();
    
    for (int i = 0; i < digits; i++) {
      int number = unusedNumbers.remove(random.nextInt(unusedNumbers.size()));
      answer[i] = (char)('0' + number);
    }
    
    return String.valueOf(answer);
  }
  
  static Boolean isDuplicated(String answer) {
    Set<Character> existedCharacters = new HashSet<>();
    
    for (char c : answer.toCharArray()) {
      if (existedCharacters.contains(c)) {
        return true;
      }
      
      existedCharacters.add(c);
    }

    return false;
  }
  
  static HitAndBlow countHitsAndBlows(String a, String b) {
    int countHits = 0;
    int countBlows = 0;
    
    for (int i = 0; i < NUMBER_OF_DIGITS; i++) {
      if (a.charAt(i) == b.charAt(i)) {
        countHits++;
        continue;
      }
      
      for (int j = 0; j < NUMBER_OF_DIGITS; j++) {
        if (a.charAt(i) == b.charAt(j)) {
          countBlows++;
        }
      }
    }
    
    return new HitAndBlow(countHits, countBlows);
  }
  
  static class HitAndBlow {
    final int hits;
    final int blows;
    
    public HitAndBlow(int hits, int blows) {
      this.hits = hits;
      this.blows = blows;
    }
    
    public int getHits() { return hits; }
    public int getBlows() { return blows; }
  }
}
