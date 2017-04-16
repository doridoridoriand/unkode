package com.doridoridoriand.HitAndBlow;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.Random;
import java.util.Scanner;
import java.util.Set;
import java.util.ArrayList;
import java.util.Collections;

public class Main {
  static final int NUMBER_OF_DIGITS = 4;

  public static void main(String[] args) {
    // メソッド作るでごんす
    String expectedAnswer = generateRandomAnswer(NUMBER_OF_DIGITS);

    System.out.println("これからHit and Blow を始めます。" + NUMBER_OF_DIGITS + "桁の整数を入力してください。");

    // Scannerはオートクローズするのでエラー出るかわからぬ
    // こんなかで処理を済ませていくよ
    for (int counter = 0; ; counter++) {
      Scanner scanner = new Scanner(System.in);
      String answer = scanner.next();
      if (inputContentValidation(answer) != null) {
        HitAndBlow result = countHitsAndBlows(answer, expectedAnswer);
        System.out.println("ヒット: " + result.getHits() + ", ブロー: " + result.getBlows());

        if (result.getHits() == NUMBER_OF_DIGITS) {
          System.out.println(counter + "回目でクリア!!");
          System.out.println("おめでとうございます");
          break;
        }
      }
    }
  }

  // なんかこれ微妙かも
  static String generateRandomAnswer(int digits) {
    LinkedList<Integer> unusedNumbers = new LinkedList<>();

    for (int i = 0; i < digits; i++) {
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

  static String inputContentValidation(String digits) {
    String err = "";
    if (digits.length() != NUMBER_OF_DIGITS) {
      err = "入力した桁数に誤りがあります";
    }

    if (!isNumber(digits)) {
      err = "入力内容は数字のみです";
    }

    if (isDuplicated(digits)) {
      err = "入力した数字に重複があります。全て異なった数字を入力してください";
    }
    return err;
  }

  private static boolean isDuplicated(String digits) {
    Set<Character> originString = new HashSet<>();
    for (char character : digits.toCharArray()) {
      if (originString.contains(character)) {
        return true;
      }
    }
    return false;
  }

  private static boolean isNumber(String digits) {
    try {
      Integer.parseInt(digits);
        return true;
    }
    catch (NumberFormatException error){
      return false;
    }
  }

  static HitAndBlow countHitsAndBlows(String a, String b) {
    int countHits  = 0;
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
